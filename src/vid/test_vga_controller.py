import pytest


from .vga_controller import ClockDivider

from nmigen.back.pysim import Delay, Simulator, Tick


@pytest.mark.parametrize('divisor', [2,4,6,8,10,16])
def test_clock_divider(divisor):
    four_div = ClockDivider(divisor=divisor, use_external_clock=False)

    sim = Simulator(four_div)
    sim.add_clock(1e-6)
    def process():
        # go through 4 cycles checking the results
        cycle_count = divisor * 6 
        trace = []
        for i in range(cycle_count):
            # store trace
            trace.append((yield four_div.out_clock))
            yield   # move forward one frame

        # check that the trace would be right
        expected_trace = [
            0 if (i // divisor) % 2 == 0 else 1
            for i in range(cycle_count)
        ]

        assert expected_trace == trace
    sim.add_sync_process(process)
    sim.run()


def test_clock_divider_external_clock():
    two_div = ClockDivider(divisor=2, use_external_clock=True)

    sim = Simulator(two_div)
    sim.add_clock(1e-6)
    def process():

        # confirm the right initial state for our clocks
        assert (yield two_div.in_clock) == 0
        assert (yield two_div.out_clock) == 0
        assert (yield two_div.prev_clock_state) == 0
        # now let's cycle the in clock.
        yield two_div.in_clock.eq(1); yield
        # after the first tick the prev clock state hasn't updated to the new value yet
        assert (yield two_div.prev_clock_state) == 0
        # then after that we're good though
        yield
        assert (yield two_div.prev_clock_state) == 1
        yield two_div.in_clock.eq(0); yield; yield;
        assert (yield two_div.prev_clock_state) == 0
        # at this point we should have gotten the out clock to 1
        assert (yield two_div.in_clock) == 0
        assert (yield two_div.out_clock) == 1
        # now let's yield twice without touching the two_div clock
        yield; yield;
        yield; yield;
        # still, out clock didn't move (because in_clock hasn't)
        assert (yield two_div.in_clock) == 0
        assert (yield two_div.out_clock) == 1
        # trigger in clock once...
        yield two_div.in_clock.eq(1); yield; yield;
        # still, nothing
        assert (yield two_div.in_clock) == 1
        assert (yield two_div.out_clock) == 1
        # but one more trigger gets us there
        yield two_div.in_clock.eq(0); yield; yield;
        assert (yield two_div.in_clock) == 0
        assert (yield two_div.out_clock) == 0

    sim.add_sync_process(process)
    sim.run()
