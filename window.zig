const std = @import("std");
usingnamespace std.os.windows;

pub const WNDPROC = ?extern fn (HWND, UINT, WPARAM, LPARAM) LRESULT;
pub const HWND = HANDLE;
pub const LPARAM = i64;
pub const WPARAM = u64;
pub const LRESULT = i64;

pub const WNDCLASS = extern struct {
    style: UINT,
    wndProc: WNDPROC,
    cbClsExtra: c_int,
    cbWndExtra: c_int,
    hInstance: ?HANDLE,
    hIcon: ?HANDLE,
    hCursor: ?HANDLE,
    hbrBackground: ?HANDLE,
    lpszMenuName: ?LPCTSTR,
    lpszClassName: LPCTSTR,
};

const POINT = extern struct {
    x: LONG,
    y: LONG,
};

const MSG = extern struct {
    hwnd: HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
};

extern "user32" stdcallcc fn RegisterClassA(
    lpWndClass: [*c]const WNDCLASS) c_ushort;

extern "user32" stdcallcc fn DefWindowProcA(
    hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT;

extern "user32" stdcallcc fn CreateWindowExA(
    dwExStyle: DWORD, lpClassName: LPCSTR, lpWindowName: LPCSTR,
    dwStyle: DWORD, x: c_int, y: c_int, nWidth: c_int, nHeight: c_int,
    hWndParent: ?HWND, hMenu: ?HANDLE, hInstance: ?HANDLE, lpParam: ?LPVOID) HWND;

export fn WndProc(hWnd: HWND, message: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT {
    return DefWindowProcA(hWnd, message, wParam, lParam);
}

extern "user32" stdcallcc fn PeekMessageA(
    msg: *MSG,
    hwnd: ?HWND,
    wMsgFilterMin: UINT,
    wMsgFilterMax: UINT,
    wRemoveMsg: UINT) c_int;

extern "user32" stdcallcc fn TranslateMessage(msg: [*c]MSG) c_int;

extern "user32" stdcallcc fn DispatchMessageA(msg: [*c]MSG) LRESULT;
    
pub fn CreateWin() bool {
    const wc = WNDCLASS {
        .style = 0,
        .wndProc = WndProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = null,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = "My window",
    };
    _ = RegisterClassA(&wc);

    const windowStyle: c_uint = @as(c_uint,
        0x10000000 | 0xc00000 | 0x80000 | 0x40000 | 0x20000 | 0x10000);

    var hWnd: HWND = CreateWindowExA(@as(DWORD, 0),
                        wc.lpszClassName, wc.lpszClassName,
                        @as(DWORD, windowStyle), @as(c_int, -2147483648),
                        @as(c_int, -2147483648), 200, 200,
                        null,
                        null,
                        null,
                        null);

    return true;
}

pub fn UpdateWindow() void {
    var msg: MSG = undefined;
    const PM_REMOVE: c_uint = 1;
    while (PeekMessageA(&msg, null, 0, 0, PM_REMOVE) != 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageA(&msg);
    }
}
