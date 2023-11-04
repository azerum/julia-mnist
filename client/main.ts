declare var brushSize: HTMLInputElement;

declare var drawingMode: HTMLInputElement;
declare var reply: HTMLElement;

declare var clear: HTMLButtonElement;
declare var classify: HTMLButtonElement;
declare var answer: HTMLInputElement;
declare var state: HTMLElement;

declare var grid: HTMLDivElement;

const gridSide = 28;
const centerX = gridSide / 2;
const centerY = gridSide / 2 - 1;

let cells: number[] = Array(gridSide * gridSide);
const cellsDivs: HTMLDivElement[] = [];

function buildGrid() {
    let drawing = false;
    
    document.addEventListener('mousedown', () => drawing = true);
    document.addEventListener('mouseup', () => drawing = false);
    
    for (let y = 0; y < gridSide; ++y) {
        for (let x = 0; x < gridSide; ++x) {
            const div = document.createElement('div');
            div.draggable = false;
    
            const draw = () => brush(x, y);
    
            div.addEventListener('mouseover', () => {
                if (drawing) {
                    draw();
                }
            });
    
            div.addEventListener('mousedown', draw);
    
            cellsDivs.push(div);
            grid.appendChild(div);
        }
    }
}

function brush(x: number, y: number) {
    const brushRadius = Number(brushSize.value);
    const wholeRadius = Math.ceil(brushRadius);

    for (let dx = -wholeRadius; dx <= wholeRadius; ++dx) {
        for (let dy = -wholeRadius; dy <= wholeRadius; ++dy) {
            const distance = Math.hypot(dx, dy);

            const ax = x + dx;
            const ay = y + dy;

            if (isOutside(ax, ay)) {
                continue;
            }

            if (distance > brushRadius) {
                continue;
            }

            const i = coordsToI(ax, ay);

            const pressure = (1 - distance / brushRadius);
            const total = Math.min(1, cells[i] + pressure);

            cells[i] = total;
            
            const div = cellsDivs[i];
            setDivColor(div, total);
        }
    }
}

function isOutside(x: number, y: number): boolean {
    return (x < 0 || x > gridSide - 1) || (y < 0 || y > gridSide - 1);
}

function coordsToI(x: number, y: number): number {
    return x + y * gridSide;
}

function iToCoords(i: number): [number, number] {
    const x = i % gridSide;
    const y = Math.ceil(i / gridSide);

    return [x, y];
}

function setDivColor(div: HTMLDivElement, color: number) {
    const gray = Math.floor(color * 255);
    div.style.backgroundColor = `rgb(${gray}, ${gray}, ${gray})`;
}

function setDivsToCells() {
    for (let i = 0; i < cells.length; ++i) {
        const div = cellsDivs[i];
        setDivColor(div, cells[i]);
    }
}

function clearCells() {
    cells.fill(0);

    for (const div of cellsDivs) {
        (div as any).style.backgroundColor = 'black';
    }
}

cells.fill(0);
buildGrid();

const ws = new WebSocket('ws://localhost:8000');

clear.onclick = () => {
    cells.fill(0);
    setDivsToCells();

    if (drawingMode.checked) {
        reply.textContent = '';
    }
};

classify.onclick = () => {
    ws.send(JSON.stringify(cells));
    answer.value = '';
};

ws.onopen = () => {
    state.textContent = 'Connected';
};

ws.onclose = () => {
    state.textContent = 'Closed';
};

ws.onmessage = ev => {
    if (drawingMode.checked) {
        reply.textContent = 'Saved';
        return;
    }

    answer.value = ev.data;
};
