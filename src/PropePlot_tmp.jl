using Revise
using GLMakie, USTB.UFF

GLMakie.activate!(framerate=60, vsync=true)

prb = CurvilinearArray();
prb.N = 128; prb.pitch = 500e-6; prb.radius = 70e-3;


plot(prb.probe)

display(f)