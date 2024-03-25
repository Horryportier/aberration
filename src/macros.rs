/// NOTE: dont use it its only for fast macro expansion
#[macro_export]
macro_rules! spritesheet {
    ($file:literal, $size:expr ,  $rows:expr , $colums:expr, $ass:ident, $tas:ident) => {
        let texture_handle: Handle<Image> = $ass.load($file);
        let layout = TextureAtlasLayout::from_grid($size, $rows, $colums, None, None);
        let texture_atlas_layout = $tas.add(layout);
    };
}
