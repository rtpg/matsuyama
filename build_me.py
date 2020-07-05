import megabuild
from megabuild import FileInput


@megabuild.task
def build_imgs(m):
    m.use_input(FileInput("sample_sprite.bmp"))
    
    m.declare_output([
        "img/1.mem",
        "img/2.mem",
        "img/3.mem",
        "img/4.mem",
        "img/palette.mem",
    ])

    m.cache_check()

    # the below uses the sample sprite as input
    m.run_subprocess(
        ["scripts/convert_imgs.py"]
    )


if __name__ == "__main__":
    megabuild.run_task(build_imgs)
