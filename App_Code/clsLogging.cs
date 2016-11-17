using System;
using class_ADO;


namespace class_Logging
{
    public class clsLogging
    {
        public clsLogging()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void logChange(string changeUser, string changeID, string changeValOld, string changeValNew, string changeTable, string changeNote, int intBatch)
        {
            string strSQL = null;

            strSQL = "Insert into changeLog " + "(changeUser, changeDate, changeID, changeValOld, changeValNew, changeTable, changeNote, changeBatch, CreateUserId) " +
                     "Values ('" + changeUser + "', '" + DateTime.Now + "', '" + changeID + "', '" + changeValOld + "', '" + changeValNew + "', '" +
                              changeTable + "', '" + changeNote + "', " + intBatch + ", -1)";

            clsADO writeLog = new clsADO();
            writeLog.updateOrInsert(strSQL, false);
        }

        public int getBatch()
        {
            clsADO maxBatch = new clsADO();
            int intMaxBatch = 0;

            intMaxBatch = Convert.ToInt32(maxBatch.returnSingleValue("Select Max(changeBatch) from changeLog", false));

            int nextBatch = intMaxBatch + 1;

            return nextBatch;
        }
    }
}