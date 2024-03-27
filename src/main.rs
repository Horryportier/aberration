mod camera;

mod args;
mod egui_setup;
mod macros;
mod opts;
mod player;
mod shared;
mod tileset;

use anyhow::Ok;
use bevy::prelude::*;
use clap::Parser;
use egui_setup::EguiSetup;
use opts::UiType;
use shared::{
    animation,
    item::{spaw_coin, spawn_crystal},
    velocity::{Velocity, VelocityPlugin},
};

// TODO:
// - [x]  organize project
// - [x]  create inspector ui and register types
//      - [ ] make advanced dev ui
// - [x] learn how to make bundels
// - [ ] learn how to add shaders and light
// - [x] fix tilemap transform isssue
// - [ ] colision
// - [ ] create inventory

fn main() -> anyhow::Result<()> {
    let args = args::Args::parse();
    let game_options = args.exec()?;
    let ui_plugin = match game_options.ui {
        UiType::DevSimple => EguiSetup,
        _ => todo!(),
    };

    App::new()
        .insert_resource(ClearColor(Color::hex("0c0b12").unwrap()))
        .add_plugins((DefaultPlugins
            .set(WindowPlugin {
                primary_window: Some(Window {
                    title: "bevy_app".into(),
                    window_level: bevy::window::WindowLevel::AlwaysOnTop,
                    resizable: true,
                    ..Default::default()
                }),
                ..Default::default()
            })
            .set(ImagePlugin::default_nearest()),))
        .add_plugins((
            tileset::TileMapPlugin,
            camera::CameraPlugin,
            VelocityPlugin,
            player::PlayerPlugin,
            ui_plugin,
            animation::AnimationPlugin,
        ))
        .add_systems(Startup, (spawn_crystal, spaw_coin))
        .run();

    Ok(())
}
