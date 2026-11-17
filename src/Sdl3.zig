const Sdl3 = @This();
const std = @import("std");
const c_sdl3 = @import("c_sdl3");
pub const Event = @import("Sdl3/Event.zig");
pub const Window = @import("Sdl3/Window.zig");
pub const SdlError = error{InitFailure};

pub fn init() SdlError!void {
    if (!c_sdl3.SDL_Init(c_sdl3.SDL_INIT_VIDEO)) {
        return SdlError.InitFailure;
    }
}

pub fn pollEvent() ?Event {
    var event: c_sdl3.SDL_Event = undefined;
    if (c_sdl3.SDL_PollEvent(&event)) {
        const event_type: Event.Type = @fromBackingInt(@as(u32, event.type));

        switch (event_type) {
            .key_down => {
                return .{
                    .type = event_type,
                    .key = @fromBackingInt(@as(u32, event.key.key)),
                };
            },
            else => {
                return .{
                    .type = event_type,
                    .key = Event.Key.unknown,
                };
            },
        }
    } else {
        return null;
    }
}

pub fn deinit() void {
    Sdl3.quit();
}

pub fn quit() void {
    c_sdl3.SDL_Quit();
}
