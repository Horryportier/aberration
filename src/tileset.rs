use bevy::prelude::*;
use rand::Rng;

use crate::shared::consts::BACKGROUND_TILES_LAER;

pub struct TileMapPlugin;

impl Plugin for TileMapPlugin {
    fn name(&self) -> &str {
        "TileMapPlugin (v1)"
    }
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, spawn_tilemap);
    }
}

const TILEMAP_SIZE: i32 = 20;

#[derive(Component, Debug, Clone, Copy)]
pub struct TileMap {
    pub tile_size: i32,
    pub map_size: i32,
}

#[derive(Component, Clone, Copy, Deref, DerefMut, Debug, Default)]
pub struct Tile(IVec2);

impl Tile {
    fn new(x: i32, y: i32) -> Self {
        Tile(IVec2::new(x, y))
    }
}

fn spawn_tilemap(
    mut commands: Commands,
    asset_server: Res<AssetServer>,
    mut texture_atlas_layouts: ResMut<Assets<TextureAtlasLayout>>,
) {
    let texture = asset_server.load("tileset.png");
    let layout = TextureAtlasLayout::from_grid(Vec2::new(32., 32.), 10, 10, None, None);
    let texture_atlas_layout = texture_atlas_layouts.add(layout);

    let tilemap = TileMap {
        tile_size: 32,
        map_size: TILEMAP_SIZE,
    };

    let make_tile = |x: i32, y: i32, z: f32, size: i32| {
        (
            SpriteSheetBundle {
                texture: texture.clone(),
                atlas: TextureAtlas {
                    layout: texture_atlas_layout.clone(),
                    index: rand::thread_rng().gen_range(0..5),
                },
                transform: Transform::from_xyz((x * size) as f32, (y * size) as f32, z),
                ..Default::default()
            },
            Tile::new(x, y),
        )
    };

    commands
        .spawn((tilemap, SpatialBundle::default()))
        .with_children(|parent| {
            for x in 0..tilemap.map_size {
                for y in 0..tilemap.map_size {
                    parent.spawn(make_tile(x, y, BACKGROUND_TILES_LAER, tilemap.tile_size));
                }
            }
        });
}
