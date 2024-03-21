use bevy::prelude::*;

use crate::{velocity::Speed, Velocity};

#[derive(Component)]
pub struct Player;

pub struct PlayerPlugin;

const PLAYER_Z_INDEX: f32 = 10.;

impl Plugin for PlayerPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, spawn_player)
            .add_systems(Update, player_movement);
    }
}

pub fn spawn_player(mut commands: Commands, assets_server: Res<AssetServer>) {
    let texture_handle = assets_server.load("sword.png");

    commands.spawn((
        SpriteBundle {
            texture: texture_handle,
            transform: Transform::default().with_translation(Vec3::new(0., 0., PLAYER_Z_INDEX)),
            ..Default::default()
        },
        Player,
        Speed(2.),
        Velocity(Vec3::default()),
    ));
}

fn player_movement(
    mut player: Query<(&mut Velocity, &Speed), With<Player>>,
    keys: Res<ButtonInput<KeyCode>>,
) {
    let Ok((mut v, s)) = player.get_single_mut() else {
        return;
    };
    let s = **s;
    let mut key_vel = Velocity(Vec3::default());

    if keys.pressed(KeyCode::KeyD) {
        key_vel.x += s;
    }

    if keys.pressed(KeyCode::KeyA) {
        key_vel.x -= s;
    }

    if keys.pressed(KeyCode::KeyW) {
        key_vel.y += s;
    }

    if keys.pressed(KeyCode::KeyS) {
        key_vel.y -= s;
    }

    v.0 += key_vel.0;
}
