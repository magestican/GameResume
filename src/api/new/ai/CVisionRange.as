package api.ai 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CVisionRange 
	{
		var fieldOfViewAngle
		var playerInSight
		var lastPositionPlayerSighted
		public function CVisionRange(aDistance:uint,aRadious:uint) 
		{
			
		}
		
		/*
		// Create a vector from the enemy to the player and store the angle between it and forward.
            Vector3 direction = other.transform.position - transform.position;
            float angle = Vector3.Angle(direction, transform.forward);
            
            // If the angle between forward and where the player is, is less than half the angle of view...
            if(angle < fieldOfViewAngle * 0.5f)
            {
                RaycastHit hit;
                
                // ... and if a raycast towards the player hits something...
                if(Physics.Raycast(transform.position + transform.up, direction.normalized, out hit, col.radius))
                {
                    // ... and if the raycast hits the player...
                    if(hit.collider.gameObject == player)
                    {
                        // ... the player is in sight.
                        playerInSight = true;
                        
                        // Set the last global sighting is the players current position.
                        lastPlayerSighting.position = player.transform.position;
                    }
                }
            }*/
	}

}