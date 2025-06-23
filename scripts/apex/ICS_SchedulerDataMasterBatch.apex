/** 
 * @author: Javier Armando Tibamoza Cubillos
 * @date: 2025-06-22
 * @version: 1.0
 * @email: javier.tibamoza.cubillos@gmail.com
 * @decription:
 * Schedules a job to run the ICS_DataMasterBuilder_sch class every day at 6:00 AM.
 * The job will execute the logic defined in the ICS_DataMasterBuilder_sch class.
 * cronExp defines the schedule in a cron-like format.
 * Seconds Minutes Hours Day_of_month Month Day_of_week Year(optional)
    0        0       *     *            *     ?         (sin año = todos)
*/
String cronExp = '0 0 * * * ?'; // Cada hora en punto
String jobName = 'ICS_DataMasterBuilder_sch';

ICS_DataMasterBuilder_sch job = new ICS_DataMasterBuilder_sch();
System.schedule(jobName, cronExp, job);