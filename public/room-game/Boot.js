var RoomGame = {}

RoomGame.Boot = function () {}

RoomGame.Boot.prototype = {
    preload: function () {
        this.input.maxPointers = 1;
        this.scale.pageAlignHorizontally = true;
        this.scale.pageAlignVertically = true;

        game.stage.disableVisibilityChange = true;


        //this.load.image('hotdog', 'assets/hotdog.png');
    },

    create: function () {
        this.state.start('RoomGame.Preload');
    }
}
