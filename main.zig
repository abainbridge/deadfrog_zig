const df_win = @import("window.zig");
const std = @import("std");

pub export fn main() u8 {
    _ = df_win.CreateWin();
                        
    while (true) {
        df_win.UpdateWindow();
        std.time.sleep(10);
    }
    
    return 0;
}
