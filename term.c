#include <sys/ioctl.h>
#include <unistd.h>
#include <assert.h>

typedef struct
{
    unsigned int x;
    unsigned int y;
} Vector2;

Vector2 get_terminal_width_and_height()
{
    struct winsize w;
    assert((ioctl(STDOUT_FILENO, TIOCGWINSZ, &w)) == 0);
    return (Vector2){w.ws_row, w.ws_col};
}
