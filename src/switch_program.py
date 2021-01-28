from nmigen import Elaboratable, Module

from basys_platform import Basys3Platform


class SwitchProg(Elaboratable):
    def __init__(self, platform):
        m = Module()

        led1 = platform.request("ld1", 0)
        led2 = platform.request("ld2", 0)
        switch = platform.request("v16", 0)
        m.d.comb += led1.o.eq(1)
        m.d.comb += led2.o.eq(~switch)

        return m


if __name__ == "__main__":
    Basys3Platform().build(SwitchProg(), do_program=True)
