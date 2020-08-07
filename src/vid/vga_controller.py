from nmigen import *
from nmigen.cli import *
from contextlib import contextmanager

import math as math

class ClockDivider(Elaboratable):
    """
    From an input clock, generate a clock that is divisor times slower

    when using an external clock, that external clock _needs to be at least 2x as slow_ as the system clock

    (Because the logic below requires )
    """
    def __init__(self, divisor, use_external_clock=False):
        self.use_external_clock = use_external_clock
        self.divisor = divisor
        if self.divisor % 2:
            raise ValueError("This only supports even divisors at the moment")
        if use_external_clock:
           self.in_clock = Signal()
           # exposing for testing purposes
           self.prev_clock_state = Signal()
        else:
            self.in_clock = None
            self.prev_clock_state = None
        self.out_clock = Signal()

    def elaborate(self, platform):
        m = Module()

        # this counter needs to hold enough bits to count up to self.divisor - 1
        counter = Signal(max(math.ceil(math.log2(self.divisor)), 1))
        
        with m.If(self.prev_clock_state != self.in_clock if self.use_external_clock else True):
            # then we're on an edge, "count"
            
            with m.If(counter == (self.divisor-1)):
                # the counter == 0 stuff is to handle perfect powers of 2
                m.d.sync += [
                    counter.eq(0),
                    self.out_clock.eq(~self.out_clock),
                ]
            with m.Else():
                m.d.sync += counter.eq(counter + 1)
        # keep previous clock state (if we are using an external clock)
        if self.use_external_clock:
            m.d.sync += self.prev_clock_state.eq(self.in_clock)

        return m


@contextmanager
def posedge(m, signal):
    """
    Run the inner block whenever the incoming signal goes from 0 to 1
    """
    prev_signal_state = Signal()
    # run the block within that change
    with m.If((prev_signal_state == 0) and (signal == 1)):
        yield
    # also synchronously set the previous signal to previous value
    m.d.sync += [prev_signal_state.eq(signal)]


class VgaCtrl(Elaboratable):

    def __init__(self):
        self.current_x = Signal(reset=0, shape=13)
        self.current_y = Signal(reset=0, shape=13)
        self.active = Signal()
        self.h_sync = Signal()
        self.v_sync = Signal()

    def elaborate(self, platform):
        pass

if __name__ == "__main__":
    clock = ClockDivider(divisor=4, use_external_clock=False)
    # import ipdb;ipdb.set_trace()
    main(clock, ports=[clock.out_clock])
