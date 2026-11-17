const std = @import("std");
const Sdl3 = @import("Sdl3.zig");

const GameContext = struct {
    gpa: std.mem.Allocator,
    arena: std.mem.Allocator,
    io: std.Io,
    running: bool = true,
    window: Sdl3.Window,
};

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const arena = init.arena.allocator();
    const io = init.io;

    try Sdl3.init();
    defer Sdl3.deinit();

    var sdl_window: Sdl3.Window = try .init("SDL3 Zig", 800, 600, 0);
    defer sdl_window.deinit();

    var game_context: GameContext = .{ .gpa = gpa, .arena = arena, .window = sdl_window, .io = io };
    try run_game(&game_context);
}

fn run_game(game_context: *GameContext) !void {
    var window = game_context.window;

    while (game_context.running) {
        handle_events(game_context);

        try window.setRenderDrawColor(30, 40, 80, 90);
        try window.renderClear();
        try window.renderPresent();
    }
}

fn handle_events(game_context: *GameContext) void {
    while (Sdl3.pollEvent()) |event| {
        if (event.type == .quit) {
            game_context.running = false;
        } else if (event.type == .key_down and event.key == .escape) {
            game_context.running = false;
        } else {
            break;
        }
    }
}
