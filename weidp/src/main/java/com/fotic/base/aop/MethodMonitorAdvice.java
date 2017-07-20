package com.fotic.base.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StopWatch;

@Aspect
public class MethodMonitorAdvice {
	private static Logger logger = LoggerFactory.getLogger(MethodMonitorAdvice.class);

    @Pointcut("execution(* com.fotic..service.impl.*.*(..))")
    private void serviceMethod() {
    }

    /**
     * 日志输出, service层的方法调用和执行时间
     * @param pjp
     * @return
     * @throws Throwable
     */
    @Around("serviceMethod()")
    public Object methodRunningTime(ProceedingJoinPoint pjp) throws Throwable {
    	
    	String methodPath = new StringBuffer(pjp.getTarget().getClass().getName()).append(".").append( pjp.getSignature().getName()).toString();
       
    	StopWatch watch = new StopWatch();
        logger.info("{}:{}", methodPath, " in method...");  
        // start stopwatch
        watch.start();
        Object retVal = pjp.proceed();
        // stop stopwatch
        watch.stop();
        Long time = watch.getTotalTimeMillis();
        logger.info("{}:{}", methodPath, new StringBuffer(" out method, cost : ").append(time).append("ms"));  
        return retVal;
    }
	
}
