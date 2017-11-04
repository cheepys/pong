extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)
var left_paddle = "0"
var right_paddle = "0"

const INITIAL_BALL_SPEED = 80
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 150

func _ready():
    screen_size = get_viewport_rect().size
    pad_size = get_node("left").get_texture().get_size()
    get_node("left_paddle").set_text(left_paddle)
    get_node("right_paddle").set_text(right_paddle)
    set_process(true)

func _process(delta):
    var ball_pos = get_node("ball").get_pos()
    var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
    var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
    ball_pos += direction * ball_speed * delta
    if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
        direction.y = -direction.y
    if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
        if (left_rect.has_point(ball_pos) and direction.x < 0):
            leftScores()
        if(right_rect.has_point(ball_pos) and direction.x > 0):
            rightScores()
        direction.x = -direction.x
        direction.y = randf()*2.0 - 1
        direction = direction.normalized()
        ball_speed *= 1.1

    if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
        if (ball_pos.x < 0):
            leftmiss()
        if (ball_pos.x > screen_size.x > 0):
            righttmiss()
        ball_pos = screen_size*0.5
        ball_speed = INITIAL_BALL_SPEED
        direction = Vector2(-1, 0)
    get_node("ball").set_pos(ball_pos)
    var left_pos = get_node("left").get_pos()

    if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
        left_pos.y += -PAD_SPEED * delta
    if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
        left_pos.y += PAD_SPEED * delta

    get_node("left").set_pos(left_pos)

# Move right pad
    var right_pos = get_node("right").get_pos()

    if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
        right_pos.y += -PAD_SPEED * delta
    if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
        right_pos.y += PAD_SPEED * delta

    get_node("right").set_pos(right_pos)

func leftScores():
    var score = left_paddle.to_int()
    score+=1
    left_paddle = String(score)
    get_node("left_paddle").set_text(left_paddle)

func rightScores():
    var score2 = right_paddle.to_int()
    score2+=1
    right_paddle = String(score2)
    get_node("right_paddle").set_text(right_paddle)

func leftmiss():
    var score = left_paddle.to_int()
    score-=1
    left_paddle = String(score)
    get_node("left_paddle").set_text(left_paddle)

func righttmiss():
    var score = right_paddle.to_int()
    score-=1
    right_paddle = String(score)
    get_node("right_paddle").set_text(right_paddle)