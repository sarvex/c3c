module std::io::os;
import libc;
import std::io::path;
import std::os::win32;
import std::os::posix;

$switch
	$case env::COMPILER_LIBC_AVAILABLE && env::os_is_posix():

macro bool! native_mkdir(Path path, MkdirPermissions permissions)
{
	if (!posix::mkdir(path.as_zstr(), permissions == NORMAL ? 0o777 : 0o700)) return true;
	switch (libc::errno())
	{
		case errno::EACCES:
		case errno::EPERM:
		case errno::EROFS:
		case errno::EFAULT: return IoError.NO_PERMISSION?;
		case errno::ENAMETOOLONG: return IoError.NAME_TOO_LONG?;
		case errno::EDQUOT:
		case errno::ENOSPC: return IoError.OUT_OF_SPACE?;
		case errno::EISDIR:
		case errno::EEXIST: return false;
		case errno::ELOOP: return IoError.SYMLINK_FAILED?;
		case errno::ENOTDIR: return IoError.FILE_NOT_FOUND?;
		default: return IoError.GENERAL_ERROR?;
	}
}

	$case env::COMPILER_LIBC_AVAILABLE && env::os_is_win32():

macro bool! native_mkdir(Path path, MkdirPermissions permissions)
{
	@pool()
    {
        // TODO security attributes
		if (win32::win32_CreateDirectoryW(path.as_str().to_temp_utf16()!!, null)) return true;
		switch (win32::win32_GetLastError())
		{
			case win32::ERROR_ACCESS_DENIED:
				return IoError.NO_PERMISSION?;
			case win32::ERROR_DISK_FULL:
		        return IoError.OUT_OF_SPACE?;
			case win32::ERROR_ALREADY_EXISTS:
				return false;
			case win32::ERROR_PATH_NOT_FOUND:
				return IoError.FILE_NOT_FOUND?;
			default:
				return IoError.GENERAL_ERROR?;
		}
    };
}

	$default:

fn bool! native_mkdir(Path path, MkdirPermissions permissions)
{
	unreachable("'mkdir' not available");
	return false;
}


$endswitch