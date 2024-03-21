use bevy::math::UVec2;
use bevy::prelude::*;
use bevy_ecs_tilemap::map::TilemapRenderSettings;

pub struct TileSetPlugin;

impl Plugin for TileSetPlugin {
    fn build(&self, app: &mut App) {
        app.init_asset::<crate::helpers::TiledMap>()
            .add_systems(Startup, spawn_map);
    }
}

// FIX: figure out how to do tiled 3d iso and make tileset tile properly.
fn spawn_map(mut commands: Commands, asset_server: Res<AssetServer>) {
    let map_handle: Handle<crate::helpers::TiledMap> = asset_server.load("map.tmx");

    commands.spawn(crate::helpers::TiledMapBundle {
        tiled_map: map_handle,
        render_settings: TilemapRenderSettings {
            render_chunk_size: UVec2::new(3, 1),
            y_sort: true,
        },
        ..Default::default()
    });
}
