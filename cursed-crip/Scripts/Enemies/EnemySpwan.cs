using Godot;
using System;

public partial class EnemySpwan : Node
{
	[Export] public PackedScene EnemyScene;
	[Export] public float MinSpawnDistance = 300f;
	[Export] public float MaxSpawnDistance = 600f;
	[Export] public Vector2 SpawnAreaMin = new(0, 0);
	[Export] public Vector2 SpawnAreaMax = new(800, 400);
	[Export] public float SpawnIntervalMin = 1.0f;
	[Export] public float SpawnIntervalMax = 3.0f;

	[Export] public int MaxAlive = 4;

	private readonly RandomNumberGenerator _rng = new();

	public override void _Ready()
	{
		_rng.Randomize();
		SpawnLoop();
	}

	private async void SpawnLoop()
	{
		while (IsInsideTree())
		{
			if (EnemyScene != null && GetTree().GetNodesInGroup("enemies").Count < MaxAlive)
			{
				SpawnOne();
			}
			float wait = _rng.RandfRange(SpawnIntervalMin, SpawnIntervalMax);
			await ToSignal(GetTree().CreateTimer(wait), SceneTreeTimer.SignalName.Timeout);
		}
	}

	private void SpawnOne()
	{
		var enemy = EnemyScene.Instantiate<Node2D>();
		var player = GetTree().GetFirstNodeInGroup("player") as Node2D;

		if (player != null)
		{
			float angle = _rng.RandfRange(0, Mathf.Tau);
			float distance = _rng.RandfRange(MinSpawnDistance, MaxSpawnDistance);
			
			Vector2 offset = new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * distance;
			enemy.GlobalPosition = player.GlobalPosition + offset;
		}
		else
		{
			enemy.GlobalPosition = new Vector2(
				_rng.RandfRange(SpawnAreaMin.X, SpawnAreaMax.X),
				_rng.RandfRange(SpawnAreaMin.Y, SpawnAreaMax.Y)
			);
		}
		GetParent().AddChild(enemy);
		enemy.AddToGroup("enemies");
	}
}
