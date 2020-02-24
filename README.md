# 06-Juicy-Breakout

Things I did:
 - Gave bricks a color and texture
 - Ball direction depends on where it hits the paddle (whether or not game mechanics make a game feel juicier is debatable, but I think that giving the player more control over the ball improves the feel of the game)
 - Ball is shown on top of the paddle when it is being shot, player must click to shoot the ball
 - Bricks explode into particles when broken
 - The ball has a bounce animation
 - The ball now has a comet trail
 - Added background w/ shader
 - Added sound effects
 - Added paddle sprite
 - Paddle sprite has animation for when the ball bounces off of it
 - The ball's speed is controlled; it starts at 400px/s and increases speed by 10px/s for each brick broken, up to a maximum of 1000px/s.
 - Animated blocks appearing on screen
 - Gave the paddle anxiety
 - The paddle's eyes sometimes follow the ball (alternates between shifty eyes and looking at the ball)
 - Added screenshake
 - Added score text that shows up when a brick is broken
 - Animated the player picking up the ball
 - Changed Font
 - Paddle squashes and stretches with mouse movement
 - A couple minor physics tweaks, e.g. making it so that the ball's movement is never entirely horizontal (so the ball doesn't get stuck in place or take too long to reach the paddle)

This is an opportunity for you to implement some of the "juicy" features as demonstrated in the 2012 GDC presentation, "Juice it or Lose it."

I have provided a simple, generic brick breaker game, built in Godot. You can use the presentation as a guide or use your own imagination, but your assignment is to make the game feel more "juicy": kinetic, reactive, physical.

Please list the features you add in the README.md. You will be awarded one point per feature you add (including a soundtrack and sound effects). Some of the features demonstrated in the presentation include:
 - Changing the color of the paddle, ball, and blocks
 - Animate how the blocks and the paddle appear on the screen
 - Squeeze and stretch the paddle
 - Animate the size of the ball when it hits something
 - Wobble the ball after it hits something
 - Animate the color of the ball after it hits something
 - Shake the blocks or the paddle when the ball hits something
 - Add sound effects
 - Add music
 - Add particles when a block is hit
 - Add particles when the paddle is hit
 - Make the blocks fall off the screen when they are hit
 - Make the blocks rotate as they are hit
 - Break the blocks when they are hit
 - Add a comet trail to the ball
 - Add screen shake
 - Add eyes to the paddle
 - Make the eyes blink
 - Make the eyes follow the ball
 - Add a smile to the paddle and animate it based on the location of the ball
 - Add a background to the game
 - etc.

 When you are done, *update the LICENSE and README.md*, commit and push your code to GitHub, and turn in the URL for your repository on Canvas.

---

The grading criteria will be as follows:

 - [1 point] Assignment turned in on time
 - [1] Repository contains a descriptive README.md
 - [1] No (script) syntax errors
 - [1] No other runtime errors
 - [16] Features to make the game more "juicy"
