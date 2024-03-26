use bevy::prelude::*;

use crate::shared::{
    animation::{handle_animation, AnimationEnded, AnimationTimer, AnimationType, Animator},
    velocity::{Speed, Velocity},
};

#[derive(Component)]
pub struct Player;

pub struct PlayerPlugin;

const PLAYER_Z_INDEX: f32 = 10.;

impl Plugin for PlayerPlugin {
    fn build(&self, app: &mut App) {
        app.add_event::<AnimationEnded<PlayerAnimType>>()
            .register_type::<Animator<PlayerAnimType>>()
            .add_systems(Startup, spawn_player)
            .add_systems(
                Update,
                (player_movement, handle_animation::<PlayerAnimType>),
            );
    }
}

pub fn spawn_player(
    mut commands: Commands,
    assets_server: Res<AssetServer>,

    mut texture_atlas_layouts: ResMut<Assets<TextureAtlasLayout>>,
) {
    let texture_handle: Handle<Image> = assets_server.load("player.png");
    let layout = TextureAtlasLayout::from_grid(Vec2::new(32., 32.), 4, 1, None, None);
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
        Velocity(Vec2::default()),
        Animator(PlayerAnimType::Idle),
        AnimationTimer(Timer::from_seconds(0.2, TimerMode::Repeating)),
    ));
}

fn player_movement(
    mut player: Query<
        (
            &mut Velocity,
            &Speed,
            &mut Animator<PlayerAnimType>,
            &mut Sprite,
        ),
        With<Player>,
    >,
    keys: Res<ButtonInput<KeyCode>>,
) {
    let Ok((mut v, s, mut anim, mut sprite)) = player.get_single_mut() else {
        return;
    };
    let s = **s;
    let mut key_vel = Velocity(Vec2::default());

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

    if v.x.abs() <= 0.1 && v.x.abs() <= 0.1 {
        anim.0 = PlayerAnimType::Idle
    } else {
        anim.0 = PlayerAnimType::Move
    }
    if v.x > 0.1 {
        sprite.flip_x = false
    } else if v.x < 0.1 {
        sprite.flip_x = true
    }
    v.0 += key_vel.0;
}

#[derive(Debug, Component, Clone, Copy, Reflect)]
pub enum PlayerAnimType {
    Idle,
    Move,
}

impl AnimationType for PlayerAnimType {
    fn indices(&self) -> (usize, usize) {
        match self {
            Self::Idle => (0, 1),
            Self::Move => (2, 3),
        }
    }

    fn is_repeting(&self) -> bool {
        match self {
            Self::Idle => true,
            Self::Move => true,
        }
    }
}
