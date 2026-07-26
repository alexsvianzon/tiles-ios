let CANVAS_SIZE = Math.min(
    window.innerWidth, 
    window.innerHeight
);

let GRID_SIZE = 12;
let TILE_SIZE = CANVAS_SIZE / GRID_SIZE;

//test

window.instanceID = Math.random();

class Tile {
    constructor() {
        this.vertical = new Group();
        this.vertical.width = TILE_SIZE;
        this.vertical.height = TILE_SIZE;
        this.vertical.color = 'red';
        this.vertical.collider = 'none';
        this.vertical.tile = '^';

        this.horizontal = new Group();
        this.horizontal.width = TILE_SIZE;
        this.horizontal.height = TILE_SIZE;
        this.horizontal.color = 'lightgreen';
        this.horizontal.collider = 'none';
        this.horizontal.tile = '>';
        
        this.jump = new Group();
        this.jump.width = TILE_SIZE;
        this.jump.height = TILE_SIZE;
        this.jump.color = 'orange';
        this.jump.collider = 'none';
        this.jump.tile = 'j';
        
        this.bonus = new Group();
        this.bonus.width = TILE_SIZE;
        this.bonus.height = TILE_SIZE;
        this.bonus.color = 'lightblue';
        this.bonus.collider = 'kinematic';
        this.bonus.tile = 'b';
        
        this.finish = new Sprite();
        this.finish.width = TILE_SIZE;
        this.finish.height = TILE_SIZE;
        this.finish.color = 'white';
        this.finish.collider = 'none';
        this.finish.tile = '$';
        this.finish.visible = false;

        // setup the tile grid for later
        this.grid;
    }

    loadLevel(levelData) {
        if (levelData == undefined) {
            throw new Error("level non gud");
        }

        this.grid = new Tiles(
            levelData,
            TILE_SIZE / 2,
            TILE_SIZE / 2,
            TILE_SIZE,
            TILE_SIZE
        );
        
        this.grid.push(this.finish);

        this.grid.layer = 1;

        this.finish.visible = true;
    }
}

class Level {
    constructor() {
        this.tiles;
        this.data = {
            id: 1,
        };
    }
};

class Player {
    constructor() {
        // setup the player sprite
        this.sprite = new Sprite();
        this.sprite.radius = TILE_SIZE * 0.4;
        this.sprite.color = 'yellow';
        this.sprite.collider = 'kinematic';

        // setup the position
        this.x = 1;
        this.y = GRID_SIZE;

        this.sprite.x = TILE_SIZE * this.x - (TILE_SIZE / 2);
        this.sprite.y = TILE_SIZE * this.y - (TILE_SIZE / 2);

        this.currentTile = '^';
    }

    update(grid) {
        this.sprite.x = TILE_SIZE * this.x - (TILE_SIZE / 2);
        this.sprite.y = TILE_SIZE * this.y - (TILE_SIZE / 2);

        for (const t of grid) {
            if (Math.floor(t.x) === Math.floor(this.sprite.x) &&
                Math.floor(t.y) === Math.floor(this.sprite.y)) {
                
                this.currentTile = t.tile;
                return;
            }

            if (this.sprite.overlapping(t)) {
                this.currentTile = t.tile;
                return;
            }
        }

        this.currentTile = 'f';
    }

    reset() {
        this.x = 1;
        this.y = GRID_SIZE;
    }
};

class Game {
    constructor() {
        this.tiles = new Tile();
        this.player = new Player();
        this.moves = 0;

        this.level = new Level();

        this.playing = false;

        this.event_queue = new Array();
        this.bridge = new Bridge(new IOSTransport());
        this.bridge.on("load_level", (level_json) => {
            let level = JSON.parse(level_json.trim());
            this.level.tiles = level.level;

            console.log(level);

            this.tiles.loadLevel(this.level.tiles);

            this.player.reset();
            this.player.update(this.tiles.grid);

            this.playing = true;
        });

        this.bridge.on("up", () => {
            this.event_queue.push("up");
        });

        this.bridge.on("down", () => {
            this.event_queue.push("down");
        });

        this.bridge.on("left", () => {
            this.event_queue.push("left");
        });

        this.bridge.on("right", () => {
            this.event_queue.push("right");
        });

        this.bridge.on("reset", () => {
            if (this.player.currentTile == 'f') {
                this.event_queue.push("reset");
                this.playing = true
            }
        });
    }

    update() {
        if (!this.playing) return;
        
        this.player.update(this.tiles.grid);
        
        switch (this.event_queue.shift()) {
            case "up":
                if (this.player.currentTile == '^' || this.player.currentTile == 'b') {
                    this.player.y = this.player.y - 1;
                    this.moves = this.moves + 1;
                } else if (this.player.currentTile == 'j') {
                    this.player.y = this.player.y - 2;
                    this.moves = this.moves + 1;
                }

                break;
            
            case "down":
                if (this.player.currentTile == '^' || this.player.currentTile == 'b') {
                    this.player.y = this.player.y + 1;
                    this.moves = this.moves + 1;
                } else if (this.player.currentTile == 'j') {
                    this.player.y = this.player.y + 2;
                    this.moves = this.moves + 1;
                }

                break;

            case "left":
                if (this.player.currentTile == '>' || this.player.currentTile == 'b') {
                    this.player.x = this.player.x - 1;
                    this.moves = this.moves + 1;
                } else if (this.player.currentTile == 'j') {
                    this.player.x = this.player.x - 2;
                    this.moves = this.moves + 1;
                }

                break;

            case "right":
                if (this.player.currentTile == '>' || this.player.currentTile == 'b') {
                    this.player.x = this.player.x + 1;
                    this.moves = this.moves + 1;
                } else if (this.player.currentTile == 'j') {
                    this.player.x = this.player.x + 2;
                    this.moves = this.moves + 1;
                }

                break;

            case "reset":
                this.player.reset();
                this.moves = 0;
                
                this.bridge.emit("did_reset")

                break;

            case undefined:
                break;
            
            default:
                console.error(this.event_queue.at(-1));

                break;
        }
        
        this.player.update(this.tiles.grid);
        
        if (this.player.currentTile == '$') {
            this.playing = false;
            this.bridge.emit("finished");
        } else if (this.player.currentTile == 'f') {
            this.bridge.emit("player_fell");
            this.playing = false;
        }
    }
};

let game;

function setup() {
    createCanvas(CANVAS_SIZE - 1, CANVAS_SIZE - 1);
        
    requestAnimationFrame(() => {
        return;
    });
    
    game = new Game();
    window.bridge = game.bridge;
    game.bridge.receive("load_level", '{"data":{"id":1},"level":["............","............","...j.bj.>^$.","...^>j.b.>^.",">j.>^.......","b.j.>^.j.>b.","..^..j......","bjb>^..jb.j.","..jb.j....^.","j...j.>>b.^.","^...^>^.j.^.","b>j.>^j.b..."]}');
}

function draw() {
    clear();
    background('#4361ee');

    game.update();
    console.log(window.instanceID);
}
