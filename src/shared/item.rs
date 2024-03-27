use bevy::prelude::*;

use super::consts::ITEM_LAYER;
// TODO: using genrics with items can be annoying to design maybe find otehr  way of doing so

#[derive(Component, Clone, Copy, Default, Reflect, Deref, DerefMut)]
pub struct StackSize(pub i32);

pub trait ItemTypeTrait {
    fn max_stack_size(&self) -> i32 {
        64
    }
}

#[derive(Component, Default, Clone)]
pub struct ItemType<T: ItemTypeTrait + Default + Clone>(pub T);

#[derive(Bundle, Clone, Default)]
struct GameItem<T: ItemTypeTrait + Component + Clone + Default> {
    stack_size: StackSize,
    sprite: SpriteBundle,
    item_type: ItemType<T>,
}

#[derive(Debug, Component, Clone, Default)]
pub struct Crystal1;

impl ItemTypeTrait for Crystal1 {}

pub fn spawn_crystal(mut commands: Commands, assets_server: Res<AssetServer>) {
    let texture = assets_server.load("crystal1.png");

    commands.spawn(GameItem::<Crystal1> {
        sprite: SpriteBundle {
            texture,
            transform: Transform::from_xyz(0., 0., ITEM_LAYER),
            ..Default::default()
        },
        ..Default::default()
    });
}

#[derive(Debug, Component, Clone, Default)]
pub struct Coin;

impl ItemTypeTrait for Coin {}

pub fn spaw_coin(mut commands: Commands, assets_server: Res<AssetServer>) {
    let texture = assets_server.load("coin.png");

    commands.spawn(GameItem::<Coin> {
        sprite: SpriteBundle {
            texture,
            transform: Transform::from_xyz(32., 32., ITEM_LAYER),
            ..Default::default()
        },
        ..Default::default()
    });
}
