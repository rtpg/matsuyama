from nmigen.back.pysim import Simulator
from helpers.tick import Ticker

def assert_traces(sim, component, expected_traces):
    cycle_count = max(len(t) for t in expected_traces.values())

    def process():
        result_traces = {key: [] for key in expected_traces}
        for _ in range(cycle_count):
            for key in expected_traces:
                # get the trace
                result_traces[key].append((yield getattr(component, key)))
                # move forward one frame
                yield
        assert result_traces == expected_traces

    sim.add_sync_process(process)
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
