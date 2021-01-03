from nmigen import Signal, Elaboratable, Module
import math


class Ticker(Elaboratable):
    """
    Generate a pulse every n cycles.

    on every nth cycle the out signal will be up
    """

    def __init__(self, period):
        self.period = period

        self.out = Signal()

    def elaborate(self, platform):
        m = Module()

        counter = Signal(max(math.ceil(math.log2(self.period)), 1))

        m.d.comb += [(self.out.eq(counter == self.period - 1))]

        with m.If(counter == (self.period - 1)):
            m.d.sync += [counter.eq(0)]
        with m.Else():
            m.d.sync += [counter.eq(counter+1)]

        return m
