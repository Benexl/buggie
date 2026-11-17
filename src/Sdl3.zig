const Sdl3 = @This();
const std = @import("std");
const c_sdl3 = @import("c_sdl3");
pub const Event = @import("sdl3/Event.zig");
pub const Window = @import("sdl3/Window.zig");
pub const SdlError = error{InitFailure};

pub fn init() SdlError!void {
    if (!c_sdl3.SDL_Init(c_sdl3.SDL_INIT_VIDEO)) {
        return SdlError.InitFailure;
    }
}

pub fn deinit() void {
    Sdl3.quit();
}

pub fn pollEvent() ?Event {
    var event: c_sdl3.SDL_Event = undefined;
    if (c_sdl3.SDL_PollEvent(&event)) {
        return .{
            .type = @fromBackingInt(@as(u32, event.type)),
            .key = @fromBackingInt(@as(u32, event.key.key)),
        };
    } else {
        return null;
    }
}

pub fn quit() void {
    c_sdl3.SDL_Quit();
}
