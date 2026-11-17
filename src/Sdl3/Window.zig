window: ?*c_sdl3.SDL_Window,
renderer: ?*c_sdl3.SDL_Renderer,

const Window = @This();
const c_sdl3 = @import("c_sdl3");
const SdlError = @import("../Sdl3.zig").SdlError;

pub fn init(title: [:0]const u8, width: i32, height: i32, window_flags: u64) SdlError!Window {
    var window: ?*c_sdl3.SDL_Window = null;
    var renderer: ?*c_sdl3.SDL_Renderer = null;
    if (!c_sdl3.SDL_CreateWindowAndRenderer(title, @as(c_int, width), @as(c_int, height), window_flags, &window, &renderer)) {
        return error.InitFailure;
    }
    return .{
        .window = window,
        .renderer = renderer,
    };
}

pub fn setRenderDrawColor(self: *Window, r: u8, g: u8, b: u8, a: u8) SdlError!void {
    if (!c_sdl3.SDL_SetRenderDrawColor(self.renderer, r, g, b, a)) {
        return SdlError.InitFailure;
    }
}

pub fn renderClear(self: *Window) SdlError!void {
    if (!c_sdl3.SDL_RenderClear(self.renderer)) {
        return SdlError.InitFailure;
    }
}
pub fn renderPresent(self: *Window) SdlError!void {
    if (!c_sdl3.SDL_RenderPresent(self.renderer)) {
        return SdlError.InitFailure;
    }
}

pub fn deinit(self: *Window) void {
    c_sdl3.SDL_DestroyRenderer(self.renderer);
    c_sdl3.SDL_DestroyWindow(self.window);
}
