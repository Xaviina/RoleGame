using Godot;
using System;

public partial class EnemyCharacter : CharacterBody2D
{
	 [Export] public float speed = 50f;
	 [Export] public float huntRange = 200f;
	 [Export] public float attackRange = 50f;

	private Vector2 _direction = Vector2.Right;
	private RandomNumberGenerator _rng = new RandomNumberGenerator();

	public override void _Ready()
	{
		_rng.Randomize();
		_direction = Vector2.Right.Rotated(_rng.RandfRange(0f, Mathf.Tau)).Normalized();
	}

	public override void _PhysicsProcess(double delta)
	{
		var player = GetTree().GetNodesInGroup("player");
		
		if(player.Count > 0)
		{
			Node2D player1 = (Node2D)player[0];
			float distance = GlobalPosition.DistanceTo(player1.GlobalPosition);
			
			if(distance < huntRange)
			{
				_direction = (player1.GlobalPosition - GlobalPosition).Normalized();
			}
		}
		
		Velocity = _direction * speed;
		MoveAndSlide();

		if (GetSlideCollisionCount() > 0)
		{
			var col = GetSlideCollision(0);
			var normal = col.GetNormal();
			_direction = _direction.Bounce(normal).Normalized();
			_direction = _direction.Rotated(_rng.RandfRange(-0.25f, 0.25f)).Normalized();
		}
	}
	
	private void _on_health_health_depleted()
	{
		GD.Print("Enemy defeated!");
		QueueFree(); 
	}
}
