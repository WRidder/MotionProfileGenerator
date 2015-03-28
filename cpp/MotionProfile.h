#ifndef __MOTIONPROFILE_H__
#define __MOTIONPROFILE_H__

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

/**
 * Provides a simple trapezoidal motion profile generator.
 *
 * <p>
 * Usage:
 * // Includes
 * #include "MotionProfile.h"
 *
 * // Define state functions
 * static const State stateArr[] = {
 *		State(STATE_NAME_ENTER, STATE_NAME_UPDATE, STATE_NAME_EXIT)
 * };
 *
 * </p>
 *
 * @author      Wilbert van de Ridder <l.w.vanderidder @ student.utwente.nl>
 * @version     1.0 
 * @since       2014-05-12
 */
class MotionProfile {		
	public:	
		/**	
		 * Constructor
		 * 
		 * @param int aVelocityMax maximum velocity
		 * @param int aAccelerationMax maximum acceleration
		 * @param short aMethod method of profile generation
		 */
		MotionProfile(float aVelocityMax, float aAccelerationMax, short aMethod);
		
		/**	
		 * Constructor
		 * 
		 * @param int aVelocityMax maximum velocity
		 * @param int aAccelerationMax maximum acceleration
		 * @param short aMethod method of profile generation
		 */
		MotionProfile(float aVelocityMax, float aAccelerationMax, short aMethod, int aSampleTime);
		
		void init();
		
		/**	
		 * Updates the state, generating new setpoints
		 *
		 * @param aSetpoint The current setpoint.
		 */
		float update(float aSetpoint);
		
		bool getFinished();
		void setCompFactor(int aFactor);
		void setMaxVelocity(float aMaxVelocity);
		void setMaxAcceleration(float aMaxVelocity);
		void pause();
		void reset();
	private:
		/** 	
		 * Increments the state number.
		 * 
		 * @see
		  currentState
		 */
		bool timeCalculation();
		void stateCalculation();
		void calculateConstantVelocityProfile(float);
		void calculateTrapezoidalProfile(float);
		
		static const short nrMethods = 2;
		
		float maxVelocity;
		float maxAcceleration;
		short method;

		float position;
		float oldPosition;
		float velocity;
		float oldVelocity;
		float acceleration;
		
		unsigned long lastTime;
		float delta;	
		int sampleTime;
		
		int compFactor;
		bool isFinished;	
};
#endif
