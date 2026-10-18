import voronoi;
import ppm;

const PPM_WIDTH = 800;
const PPM_HEIGHT = 800;
const MAX_SEEDS  = 30;
uint[PPM_WIDTH][PPM_HEIGHT] image = {};

const uint[*] VORONOI_COLORS = {
    0xf2d5cfff,
    0xeebebeff,
    0xf4b8e4ff,
    0xca9ee6ff,
    0xe78284ff,
    0xea999cff,
    0xef9f76ff,
    0xea6962ff,
    0xa9b665ff,
    0xd8a657ff,
    0x7daea3ff,
    0xd3869bff,
    0x89b482ff,
    0xd4be98ff,
    0xe5c890ff,
    0xa6d189ff,
    0x81c8beff,
    0x99d1dbff,
    0x85c1dcff,
    0x8caaeeff,
    0xbabbf1ff,
    0xc6d0f5ff,
    0xb5bfe2ff,
    0xa5adceff,
    0x949cbbff,
    0x838ba7ff,
    0x737994ff,
    0x62688ff,
};

fn void main()
{
    Vector2[] seeds = voronoi::generate_seeds(MAX_SEEDS, PPM_WIDTH, PPM_HEIGHT);
    voronoi::generate_voronoi(&image, PPM_WIDTH, PPM_HEIGHT, seeds, &VORONOI_COLORS);
    foreach(seed: seeds) voronoi::draw_point(&image, PPM_WIDTH, PPM_HEIGHT, seed.x, seed.y, 4, 0XFFFFFFFF);
    ppm::write_image_to_ppm_file(&image, PPM_WIDTH, PPM_HEIGHT, "voronoi.ppm")!!;
}
