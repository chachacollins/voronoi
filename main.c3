import voronoi;
import ppm;
import std::io;

const WIDTH = 800;
const HEIGHT = 800;
const MAX_SEEDS  = 30;
uint[WIDTH*HEIGHT] image = {};

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

extern fn Vector2 get_terminal_width_and_height();

fn void main()
{
    Vector2[] seeds = voronoi::generate_seeds(MAX_SEEDS, WIDTH, HEIGHT);
    voronoi::generate_voronoi(&image, WIDTH, HEIGHT, seeds, &VORONOI_COLORS);
    foreach(seed: seeds) voronoi::draw_point(&image, WIDTH, HEIGHT, seed.x, seed.y, 4, 0XFFFFFFFF);
    ppm::write_image_to_ppm_file(&image, WIDTH, HEIGHT, "voronoi.ppm")!!;

    Vector2 term_dimensions = get_terminal_width_and_height();
    float scale = min((float)term_dimensions.x / WIDTH, (float)term_dimensions.y * 2.0f / HEIGHT);
    uint new_width  = (uint)(WIDTH  * scale);
    uint new_height = (uint)(HEIGHT * scale / 2.0f);
    uint[] term_image = mem::new_array(uint, (sz)new_width*new_height);
    for (uint y = 0; y < new_height; y++) 
    {
        for (uint x = 0; x < new_width; x++) 
        {
            uint src_x = x * WIDTH  / new_width;
            uint src_y = y * HEIGHT / new_height;
            term_image[y * new_width + x] = image[src_y * WIDTH + src_x];
        }
    }
    for(uint y = 0; y < new_height; y++)
    {
        for(uint x = 0; x < new_width; x++)
        {
            uint pixel = term_image[y*new_width + x];
            char r = (char)((pixel >> 8*3) & 0XFF);
            char g = (char)((pixel >> 8*2) & 0XFF);
            char b = (char)((pixel >> 8*1) & 0XFF);
            io::printf("\x1b[38;2;%d;%d;%dm#\x1b[0m", r, g, b);
        }
        io::print("\n");
    }
}
