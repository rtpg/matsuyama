from nmigen import *
from nmigen.back.pysim import *

class Counter(Elaboratable):
    def __init__(self, width):
        self.v = Signal(width)

    def elaborate(self, platform):
        m = Module()
        m.d.sync += self.v.eq(self.v + 1)
        return m

if __name__ == "__main__":
    counter = Counter(width=4)
    with Simulator(counter) as sim:
        def process():
            for i in range(20):
                print("count =", (yield counter.v))
                yield Tick()
        sim.add_clock(1e-6)
        sim.add_sync_process(process)
        sim.run()
