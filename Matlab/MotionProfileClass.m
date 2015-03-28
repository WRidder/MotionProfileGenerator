classdef MotionProfileClass < handle
   % The following properties can be set only by class methods
   properties (SetAccess = private)
      maxVelocity = 0;
      maxAcceleration = 0;
      method = 1;
      position = 0;
      oldPosition = 0;
      velocity = 0;
      oldVelocity = 0;
      acceleration = 0;
      lastTime = 0;
      delta = 0;
      nrMethods = 2;
   end
   methods
      % Constructor
      function MP = MotionProfileClass(aVelocityMax,aAccelerationMax, aMethod)
         MP.maxVelocity = aVelocityMax;
         MP.maxAcceleration = aAccelerationMax;
         MP.method = aMethod;
         
         % Check method
         if MP.method < 0 || MP.method > MP.nrMethods - 1
             MP.method = 1;
         end
      end
      
      % Public methods
      function valid = timeCalculation(MP, time)
         if (MP.lastTime == 0)
             MP.lastTime = time;
             valid = false;
         else
             MP.delta = (time - MP.lastTime);  
             MP.lastTime = time;
             valid = true;
         end
      end
      
      function update(MP, aSetpoint, time)
         timeValid = MP.timeCalculation(time);
         
         % Shift state variables
         MP.oldPosition = MP.position;
         MP.oldVelocity = MP.velocity;
         
         % Calculate new setpoint if time is valid
         if (timeValid)
             MP.calculateTrapezoidalProfile(aSetpoint);
         end
         
         % Calculate state
         MP.stateCalculation();
      end
                 
      function stateCalculation(MP)
        MP.velocity = (MP.position - MP.oldPosition) / MP.delta;
        if isnan(MP.velocity) 
            MP.velocity = 0;
        end
        
        MP.acceleration = (MP.velocity - MP.oldVelocity) / MP.delta;
        if isnan(MP.acceleration) 
            MP.acceleration = 0;
        end
      end
      
      function calculateTrapezoidalProfile(MP, setpoint)
        % Checks for: max velocity, max acceleration
        % Check if we should be de-accelerating       
         if (MP.velocity^2 / MP.maxAcceleration) / 2 >= abs(setpoint - MP.position)                    
                % We need to de-accelerate
                if MP.velocity < 0 
                    MP.position = (MP.velocity + MP.maxAcceleration * MP.delta) * MP.delta + MP.position;
                elseif MP.velocity > 0
                    MP.position = (MP.velocity - MP.maxAcceleration * MP.delta) * MP.delta + MP.position;  
                end
         else
             % We're not too close yet, either accelerate or maintain velocity
             if (abs(MP.velocity) < MP.maxVelocity || (setpoint < MP.position && MP.velocity > 0) || (setpoint > MP.position && MP.velocity < 0))
                 % Accelerate, but keep in mind the maximum acceleration
                 if setpoint > MP.position
                     newSpeed = MP.velocity + MP.maxAcceleration * MP.delta;                     
                     if (newSpeed > MP.maxVelocity)
                         newSpeed = MP.maxVelocity;
                     end
                     MP.position = newSpeed * MP.delta + MP.position;
                 else
                     newSpeed = MP.velocity - MP.maxAcceleration * MP.delta;                     
                     if (abs(newSpeed) > MP.maxVelocity)
                         newSpeed = -MP.maxVelocity;
                     end
                     MP.position = newSpeed * MP.delta + MP.position;
                 end
             else
                 % Keep velocity constant at this maximum
                 if setpoint > MP.position
                    MP.position = MP.maxVelocity * MP.delta + MP.position;
                 else
                    MP.position = -MP.maxVelocity * MP.delta + MP.position;
                 end
             end
         end
      end
      % Private methods
   end % methods
end % classdef