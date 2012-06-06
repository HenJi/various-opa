MLSTATE_SHOW_LOGS = 1
EXE = robot.exe

all: $(EXE)

$(EXE): src/*.opa resources/*
	opa --slicer-check low --parser js-like src/*.opa -o $(EXE)

clean:
	rm -Rf *.exe _build _tracks *.log **/#*#

run:
	./robot.exe --verbose 8 --port 8090