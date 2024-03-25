use bevy::{prelude::*, sprite};

use crate::{
    animation::{AnimationType, Animator},
    spritesheet,
    velocity::Speed,
    Velocity,
};

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

pub fn spawn_player(
    mut commands: Commands,
    assets_server: Res<AssetServer>,

    mut texture_atlas_layouts: ResMut<Assets<TextureAtlasLayout>>,
) {
    let texture_handle: Handle<Image> = assets_server.load("player.png");
    let layout = TextureAtlasLayout::from_grid(Vec2::new(32., 32.), 1, 3, None, None);
    let texture_atlas_layout = texture_atlas_layouts.add(layout);

    commands.spawn((
        SpriteSheetBundle {
            texture: texture_handle,
            atlas: TextureAtlas {
                layout: texture_atlas_layout,
                index: 0,
            },
            transform: Transform::default().with_translation(Vec3::new(0., 0., PLAYER_Z_INDEX)),
            ..Default::default()
        },
        Player,
        Speed(2.),
        Velocity(Vec3::default()),
        PlayerAnimType::Idle,
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

#[derive(Debug, Component)]
enum PlayerAnimType {
    Idle,
    Move,
}

impl AnimationType for PlayerAnimType {
    fn indices(self) -> (usize, usize) {
        match self {
            Self::Idle => (0, 1),
            Self::Move => (2, 2),
        }
    }

    fn is_repeting(self) -> bool {
        match self {
            Self::Idle => true,
            Self::Move => false,
        }
    }
}
