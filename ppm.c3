module ppm;
import std::io;
import std::io::file;

fn void? write_image_to_ppm_file(uint *image, uint width, uint height, String filepath)
{
    File file = file::open(filepath, "wb")!;
    defer file.close();
    io::fprintf(&file, "P3\n%d %d\n255\n", width, height)!;
    for(uint i = 0; i < width * height; i++)
    {
        uint pixel = image[i];
        io::fprintf(&file, "%d %d %d\n", 
                    ((pixel >> 8 * 3) & 0xFF),
                    ((pixel >> 8 * 2) & 0xFF),
                    ((pixel >> 8 * 1) & 0xFF))!;

    }
}
