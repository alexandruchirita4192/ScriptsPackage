using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace PackagingApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            PackageContainer container = new PackageContainer(
                "..\\..\\Scripts",
                new List<PackageContainer>()
                {
                    new PackageContainer("01.ScriptVersion"),
                    new PackageContainer("02.Tables"),
                    new PackageContainer("03.DefaultData"),
                    new PackageContainer("04.Views"),
                    new PackageContainer("05.Functions"),
                    new PackageContainer("06.StoredProcedures",
                        new List<PackageContainer>()
                        {
                            new PackageContainer("01.Automatic",
                                new List<PackageContainer>()
                                {
                                    new PackageContainer("01.Extract"),   // add data to tables
                                    new PackageContainer("02.Transform"), // CalculateResults/GetResults, ChangeResults
                                    new PackageContainer("03.Load"),      // ReadResults
                                }),
                            new PackageContainer("02.ManualFix",
                                new List<PackageContainer>()
                                {
                                    new PackageContainer("01.Extract"),   // USP_GetValidTradingSessionsAndQueries
                                    new PackageContainer("02.Transform"), // delete, move data
                                    new PackageContainer("03.Load"),      // -
                                })
                        }
                        ),
                    new PackageContainer("07.PrintResults")
                });

            Console.Write("Packaging started");
            container.WritePackageContentToFile("..\\..\\Output", "MetatraderLog_DatabaseStructure.sql");
            File.Copy("..\\..\\Output\\MetatraderLog_DatabaseStructure.sql", "..\\..\\..\\MetatraderLog_DatabaseStructure.sql", true);
            Console.WriteLine(".. done!");
            Console.ReadKey();
        }
    }
}
