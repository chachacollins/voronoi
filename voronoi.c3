module voronoi;
import std::io;
import std::math::random;

struct Vector2
{
    uint x;
    uint y;
}

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

fn Vector2[] generate_seeds(uint seeds_count, int max_width, int max_height)
{
    Vector2[] seeds = mem::new_array(Vector2, seeds_count);
    foreach(&seed: seeds)
    {
        *seed = (Vector2){.x = (uint)random::rand(max_width), .y = (uint)random::rand(max_height)};
    }
    return seeds;
}

fn void generate_voronoi(uint *image, uint width, uint height, Vector2[] seeds, uint[] colors)
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

