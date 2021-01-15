from nmigen.back.pysim import Simulator, Tick
from helpers.tick import Counter, Ticker

def assert_traces(sim, component, expected_traces, input_traces=None, vcd_prefix=None):
    cycle_count = max(len(t) for t in expected_traces.values())
    if input_traces is None:
        input_traces={}

    def process():
        result_traces = {key: [] for key in expected_traces}
        for cycle in range(cycle_count):
            # set any input trace values as needed
            for key, trace in input_traces.items():
                if cycle in trace:
                    yield getattr(component, key).eq(trace[cycle])

            for key in expected_traces:
                # get the trace
                result_traces[key].append((yield getattr(component, key)))
                # move forward one frame
                yield

        # assert result_traces == expected_traces

    sim.add_sync_process(process)
    if vcd_prefix:
        vcd_expected = vcd_prefix + '.vcd'
        vcd_result = vcd_prefix + '_result.vcd'
        with sim.write_vcd(vcd_result, traces=[getattr(component, key) for key in expected_traces]):
            sim.run()
    else:
        sim.run()


def test_tick():
    ticker = Ticker(3)
    sim = Simulator(ticker)
    sim.add_clock(1e-6)

    assert_traces(
        sim,
        ticker,
        {
            'out': [0, 0, 1, 0, 0, 1, 0, 0, 1]
        }
    )


def ticks(n):
    for _ in range(n):
        yield Tick()

def test_counter():
    counter = Counter(3)

    def process():
        # set the input to up
        yield counter.input.eq(1)
        # move forward 3 frames
        yield from ticks(3)
        # assert (yield counter.out) == 1
        # move forward 1 more frame, make the input down
        yield
        yield counter.input.eq(0)
        # even waiting a while we won't have the counter up anymore
        yield from ticks(5)
        # assert (yield counter.out) == 0
        # but putting back up will get us back on track
        yield counter.input.eq(1)
        yield from ticks(2)
        # assert (yield counter.out) == 1

    sim = Simulator(counter)
    sim.add_clock(1e-6)
    assert_traces(
        sim,
        counter,
        input_traces={
            'input':{
                0: 1,
                4: 0,
                9: 1,
            }
        },
        expected_traces={
            'out': [0] + [0, 0, 1, ] + [0] * 9 + [0, 0, 1]
        },
        vcd_prefix='test_counter',
        vcd_traces=['out', '']
    )
