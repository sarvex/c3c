module std::os::win32;

typedef Win32_BOOL = int;
typedef Win32_BOOLEAN = Win32_BYTE;
typedef Win32_BYTE = char;
typedef Win32_CCHAR = cinterop::CChar;
typedef Win32_CHAR = cinterop::CChar;
typedef Win32_COLORREF = Win32_DWORD;
typedef Win32_DWORD = uint;
typedef Win32_DWORDLONG = ulong;
typedef Win32_DWORD_PTR = Win32_ULONG_PTR;
typedef Win32_DWORD32 = uint;
typedef Win32_DWORD64 = ulong;
typedef Win32_FLOAT = float;
typedef Win32_HACCEL = Win32_HANDLE;
typedef Win32_HALF_PTR = int;
typedef Win32_HANDLE = Win32_PVOID;
typedef Win32_HBITMAP = Win32_HANDLE;
typedef Win32_HBRUSH = Win32_HANDLE;
typedef Win32_HCOLORSPACE = Win32_HANDLE;
typedef Win32_HCONV = Win32_HANDLE;
typedef Win32_HCONVLIST = Win32_HANDLE;
typedef Win32_HCURSOR = Win32_HICON;
typedef Win32_HDC = Win32_HANDLE;
typedef Win32_HDDEDATA = Win32_HANDLE;
typedef Win32_HDESK = Win32_HANDLE;
typedef Win32_HDROP = Win32_HANDLE;
typedef Win32_HDWP = Win32_HANDLE;
typedef Win32_HFILE = int;
typedef Win32_HFONT = Win32_HANDLE;
typedef Win32_HGDIOBJ = Win32_HANDLE;
typedef Win32_HGLOBAL = Win32_HANDLE;
typedef Win32_HHOOK = Win32_HANDLE;
typedef Win32_HICON = Win32_HANDLE;
typedef Win32_HINSTANCE = Win32_HANDLE;
typedef Win32_HKEY = Win32_HANDLE;
typedef Win32_HKL = Win32_HANDLE;
typedef Win32_HLOCAL = Win32_HANDLE;
typedef Win32_HMENU = Win32_HANDLE;
typedef Win32_HMETAFILE = Win32_HANDLE;
typedef Win32_HMODULE = Win32_HANDLE;
typedef Win32_HMONITOR = Win32_HANDLE;
typedef Win32_HPALETTE = Win32_HANDLE;
typedef Win32_HPEN = Win32_HANDLE;
typedef Win32_HRESULT = Win32_LONG;
typedef Win32_HRGN = Win32_HANDLE;
typedef Win32_HRSRC = Win32_HANDLE;
typedef Win32_HSZ = Win32_HANDLE;
typedef Win32_HWINSTA = Win32_HANDLE;
typedef Win32_HWND = Win32_HANDLE;
typedef Win32_INT = int;
typedef Win32_INT_PTR = iptr;
typedef Win32_INT8 = ichar;
typedef Win32_INT16 = short;
typedef Win32_INT32 = int;
typedef Win32_INT64 = long;
typedef Win32_LANGID = Win32_WORD;
typedef Win32_LCID = Win32_DWORD;
typedef Win32_LCTYPE = Win32_DWORD;
typedef Win32_LGRPID = Win32_DWORD;
typedef Win32_LONG = int;
typedef Win32_LONGLONG = long;
typedef Win32_LONG_PTR = iptr;
typedef Win32_LONG32 = int;
typedef Win32_LONG64 = long;
typedef Win32_LPARAM = Win32_LONG_PTR;
typedef Win32_LPBOOL = Win32_BOOL*;
typedef Win32_LPBYTE = Win32_BYTE*;
typedef Win32_LPCOLORREF = Win32_DWORD*;
typedef Win32_LPCSTR = Win32_CCHAR*;
typedef Win32_LPCTSTR = Win32_LPCWSTR;
typedef Win32_LPCVOID = void*;
typedef Win32_LPCWSTR = Win32_WCHAR*;
typedef Win32_LPDWORD = Win32_DWORD*;
typedef Win32_LPHANDLE = Win32_HANDLE*;
typedef Win32_LPINT = int*;
typedef Win32_LPLONG = int*;
typedef Win32_LPSTR = Win32_CCHAR*;
typedef Win32_LPTSTR = Win32_LPWSTR;
typedef Win32_LPVOID = void*;
typedef Win32_LPWORD = Win32_WORD*;
typedef Win32_LPWSTR = Win32_WCHAR*;
typedef Win32_LRESULT = Win32_LONG_PTR;
typedef Win32_PBOOL = Win32_BOOL*;
typedef Win32_PBOOLEAN = Win32_BOOLEAN*;
typedef Win32_PBYTE = Win32_BYTE*;
typedef Win32_PCHAR = Win32_CHAR*;
typedef Win32_PCSTR = Win32_CHAR*;
typedef Win32_PCTSTR = Win32_LPCWSTR;
typedef Win32_PCUNICODE_STRING = Win32_UNICODE_STRING*;
typedef Win32_PCWSTR = Char16*;
typedef Win32_PDWORD = Win32_DWORD*;
typedef Win32_PDWORDLONG = Win32_DWORDLONG*;
typedef Win32_PDWORDPTR = Win32_DWORD_PTR*;
typedef Win32_PDWORD32 = Win32_DWORD32*;
typedef Win32_PDWORD64 = Win32_DWORD64*;
typedef Win32_PFLOAT = Win32_FLOAT*;
typedef Win32_PHALFPTR = Win32_HALF_PTR*;
typedef Win32_PHANDLE = Win32_HANDLE*;
typedef Win32_PHKEY = Win32_HKEY*;
typedef Win32_PINT = int*;
typedef Win32_PINTPTR = Win32_INT_PTR*;
typedef Win32_PINT8 = Win32_INT8*;
typedef Win32_PINT16 = Win32_INT16*;
typedef Win32_PINT32 = Win32_INT32*;
typedef Win32_PINT64 = Win32_INT64*;
typedef Win32_PLCID = Win32_PDWORD;
typedef Win32_PLONG = Win32_LONG*;
typedef Win32_PLONGLONG = Win32_LONGLONG*;
typedef Win32_PLONG_PTR = Win32_LONG_PTR*;
typedef Win32_PLONG32 = Win32_LONG32*;
typedef Win32_PLONG64 = Win32_LONG64*;
typedef Win32_POINTER_32 = uint;
typedef Win32_POINTER_64 = uptr;
typedef Win32_POINTER_SIGNED = iptr;
typedef Win32_POINTER_UNSIGNED = uptr;
typedef Win32_PSHORT = Win32_SHORT*;
typedef Win32_PSIZE_T = usz*;
typedef Win32_PSSIZE_T = isz*;
typedef Win32_PSTR = Win32_CHAR*;
typedef Win32_PTBYTE = Win32_TBYTE*;
typedef Win32_PTCHAR = Win32_TCHAR*;
typedef Win32_PTSTR = Win32_LPWSTR;
typedef Win32_PUCHAR = Win32_UCHAR*;
typedef Win32_PUHALFPTR = Win32_UHALF_PTR*;
typedef Win32_PUINT = Win32_UINT*;
typedef Win32_PUINTPTR = Win32_UINT_PTR*;
typedef Win32_PUINT8 = Win32_UINT8*;
typedef Win32_PUINT16 = Win32_UINT16*;
typedef Win32_PUINT32 = Win32_UINT32*;
typedef Win32_PUINT64 = Win32_UINT64*;
typedef Win32_PULONG = Win32_ULONG*;
typedef Win32_PULONGLONG = Win32_ULONGLONG*;
typedef Win32_PULONG_PTR = Win32_ULONG_PTR*;
typedef Win32_PULONG32 = Win32_ULONG32*;
typedef Win32_PULONG64 = Win32_ULONG64*;
typedef Win32_PUNICODE_STRING = Win32_UNICODE_STRING*;
typedef Win32_PUSHORT = Win32_USHORT*;
typedef Win32_PVOID = void*;
typedef Win32_PWCHAR = Win32_WCHAR*;
typedef Win32_PWORD = Win32_WORD*;
typedef Win32_PWSTR = Win32_WCHAR*;
typedef Win32_QWORD = ulong;
typedef Win32_SC_HANDLE = Win32_HANDLE;
typedef Win32_SC_LOCK = Win32_LPVOID;
typedef Win32_SERVICE_STATUS_HANDLE = Win32_HANDLE;
typedef Win32_SHORT = short;
typedef Win32_SIZE_T = usz;
typedef Win32_SSIZE_T = isz;
typedef Win32_TBYTE = Win32_WCHAR;
typedef Win32_TCHAR = Win32_WCHAR;
typedef Win32_UCHAR = char;
typedef Win32_UHALF_PTR = uint;
typedef Win32_UINT = uint;
typedef Win32_UINT_PTR = uptr;
typedef Win32_UINT8 = char;
typedef Win32_UINT16 = ushort;
typedef Win32_UINT32 = uint;
typedef Win32_UINT64 = ulong;
typedef Win32_ULONG = uint;
typedef Win32_ULONGLONG = ulong;
typedef Win32_ULONG_PTR = ulong;
typedef Win32_ULONG32 = uint;
typedef Win32_ULONG64 = ulong;
typedef Win32_USHORT = ushort;
typedef Win32_USN = Win32_LONGLONG;
typedef Win32_WCHAR = Char16;
typedef Win32_WORD = ushort;
typedef Win32_WPARAM = Win32_UINT_PTR;

const INVALID_HANDLE_VALUE = (Win32_HANDLE)(uptr)-1;

struct Win32_UNICODE_STRING
{
	Win32_USHORT length;
	Win32_USHORT maximum_length;
	Win32_PWSTR buffer;
}

union Win32_LARGE_INTEGER
{
	struct
	{
		Win32_DWORD lowPart;
		Win32_LONG  highPart;
	}
	ulong quadPart;
}

typedef Win32_CRITICAL_SECTION = distinct ulong[5];

struct Win32_SECURITY_ATTRIBUTES
{
	Win32_DWORD  nLength;
    Win32_LPVOID lpSecurityDescriptor;
	Win32_BOOL   bInheritHandle;
}

typedef Win32_LPSECURITY_ATTRIBUTES = Win32_SECURITY_ATTRIBUTES*;
typedef Win32_PSECURITY_ATTRIBUTES = Win32_SECURITY_ATTRIBUTES*;

struct Win32_STARTUPINFOW
{
	Win32_DWORD  cb;
	Win32_LPWSTR lpReserved;
	Win32_LPWSTR lpDesktop;
	Win32_LPWSTR lpTitle;
	Win32_DWORD  dwX;
	Win32_DWORD  dwY;
	Win32_DWORD  dwXSize;
	Win32_DWORD  dwYSize;
	Win32_DWORD  dwXCountChars;
	Win32_DWORD  dwYCountChars;
	Win32_DWORD  dwFillAttribute;
	Win32_DWORD  dwFlags;
	Win32_WORD   wShowWindow;
	Win32_WORD   cbReserved2;
	Win32_LPBYTE lpReserved2;
	Win32_HANDLE hStdInput;
	Win32_HANDLE hStdOutput;
	Win32_HANDLE hStdError;
}

typedef Win32_LPSTARTUPINFOW = Win32_STARTUPINFOW*;

struct Win32_STARTUPINFOEXW
{
	inline Win32_STARTUPINFOW win32_StartupInfo;
    Win32_LPPROC_THREAD_ATTRIBUTE_LIST lpAttributeList;
}

typedef Win32_LPPROC_THREAD_ATTRIBUTE_LIST = void*;
typedef Win32_LPSTARTUPINFOEXW = Win32_STARTUPINFOEXW*;

struct Win32_FILETIME
{
	Win32_DWORD dwLowDateTime;
	Win32_DWORD dwHighDateTime;
}

struct Win32_PROCESS_INFORMATION
{
	Win32_HANDLE hProcess;
	Win32_HANDLE hThread;
	Win32_DWORD  dwProcessId;
	Win32_DWORD  dwThreadId;
}

typedef Win32_PPROCESS_INFORMATION = Win32_PROCESS_INFORMATION*;
typedef Win32_LPPROCESS_INFORMATION = Win32_PROCESS_INFORMATION*;
