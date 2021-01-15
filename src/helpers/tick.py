from nmigen import Signal, Elaboratable, Module
import math


def sig_can_hold(amount):
    """
    A signal that can hold at least the amount
    """
    return Signal(
        max(
            math.ceil(
                math.log2(amount)
            ),
            1
        )
    )

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

        counter = sig_can_hold(self.period)

        m.d.comb += [(self.out.eq(counter == self.period - 1))]

        with m.If(counter == (self.period - 1)):
            m.d.sync += [counter.eq(0)]
        with m.Else():
            m.d.sync += [counter.eq(counter+1)]

        return m


class Counter(Elaboratable):
    """
    Counts every n cycles where the input is up, and sends a pulse when this has happened
    """

    def __init__(self, period):
        self.period = period

        self.input = Signal()
        self.out = Signal()
        self.counter = sig_can_hold(self.period)
    def elaborate(self, platform):
        m = Module()

        counter = self.counter

        # we will be up if the counter is _about_ to go to zero
        # => we go up on a frame that the input is up
        with m.If(self.input == 1):
            with m.If(counter == (self.period - 1)):
                m.d.sync += [
                    counter.eq(0),
                    self.out.eq(1),
                ]
            with m.Else():
                m.d.sync += [
                    counter.eq(counter+1),
                    self.out.eq(0)
                ]
        with m.Else():
            # we want to ensure the out is pulled down
            m.d.sync += [
                self.out.eq(0)
            ]
        return m
