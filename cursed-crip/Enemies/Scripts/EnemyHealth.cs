using Godot;
using System;

public partial class EnemyHealth : Node
{
	[Export] public int maxHealth = 50;
	
	private int _currentHealth;
	
	[Signal]
	public delegate void HealthDepletedEventHandler();
	
	public override void _Ready() => _currentHealth = maxHealth;
	
	public void TakeDamage(int amount)
	{
		_currentHealth -= amount;
		if(_currentHealth <= 0)
		{
			EmitSignal(SignalName.HealthDepleted);
		}
	}
}
