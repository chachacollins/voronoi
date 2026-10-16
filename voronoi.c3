import ppm;
import std::io;
import std::math::random;

struct Vector2
{
    uint x;
    uint y;
}

const HEIGHT = 800;
const WIDTH = 800;
const SEEDS_COUNT = 30;

uint[WIDTH][HEIGHT] image = {};

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

fn uint sqr_dist(uint x, uint y, uint tx, uint ty)
{
   int dx = (int)x - (int)tx;
   int dy = (int)y - (int)ty;
   return (uint)(dx * dx + dy * dy);
}

fn void clear_image(uint* image, uint width, uint height, uint color)
{
    for(uint i = 0; i < width * height; image[i++] = color);
}

fn void draw_point(uint* image, uint width, uint height, uint cx, uint cy, uint radius, uint color)
{
    uint x0 = cx - radius;
    uint y0 = cy - radius;
    uint x1 = cx + radius;
    uint y1 = cy + radius;
    for(uint x = x0; x < x1; x++)
    {
        if (x < width)
        {
            for(uint y = y0; y < y1; y++)
            {
                if (y < height)
                {
                    uint dx = cx - x;
                    uint dy = cy - y;
                    if(dx*dx + dy*dy <= radius*radius)
                    {
                        image[width*y+x] = color;
                    }
                }
            }
        }
    }
}

fn Vector2[SEEDS_COUNT] generate_seeds()
{
    Vector2[SEEDS_COUNT] seeds;
    foreach(&seed: seeds)
    {
        *seed = (Vector2){.x = (uint)random::rand(WIDTH), .y = (uint)random::rand(HEIGHT)};
    }
    return seeds;
}

fn void color_voronoi(uint *image, uint width, uint height, Vector2[] seeds, uint[] colors)
{
    for(uint y = 0; y < height; y++)
    {
        for(uint x = 0; x < width; x++)
        {
            uint j = 0;
            for(uint i = 1; i < seeds.len; i++)
            {
                if(sqr_dist(x, y, seeds[i].x, seeds[i].y) < sqr_dist(x, y, seeds[j].x, seeds[j].y))
                {
                    j = i;
                }
            }
            image[width*y+x] = colors[j%colors.len];
        }
    }
}

fn void main()
{
    clear_image(&image, WIDTH, HEIGHT, COLOR_TSODING);
    Vector2[SEEDS_COUNT] seeds = generate_seeds();
    color_voronoi(&image, WIDTH, HEIGHT, &seeds, &VORONOI_COLORS);
    foreach(seed: seeds) draw_point(&image, WIDTH, HEIGHT, seed.x, seed.y, 4, 0XFFFFFFFF);
    ppm::write_image_to_ppm_file(&image, WIDTH, HEIGHT, "voronoi.ppm")!!;
}
