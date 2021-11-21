using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace PackagingApplication
{
    class PackageContainer
    {
        #region ctor
        public PackageContainer(IEnumerable<PackageContainer> childrenList)
        {
            directory = null;
            children = childrenList.ToList();
        }
        
        public PackageContainer(string packageDirectory)
        {
            directory = packageDirectory;
            children = new List<PackageContainer>();
        }

        public PackageContainer(string packageDirectory, IEnumerable<PackageContainer> childrenList)
        {
            directory = packageDirectory;
            children = childrenList.ToList();
        }
        #endregion ctor

        #region Properties
        private string directory;
        private List<PackageContainer> children;
        #endregion Properties

        #region Methods
        public string GetPackageContent(string prefixDirectory = null)
        {
            string output = String.Empty;

            if(!String.IsNullOrEmpty(directory))
            {
                var packageDirectory = directory;
                if (!String.IsNullOrEmpty(prefixDirectory))
                    packageDirectory = prefixDirectory + "\\" + packageDirectory;
                var files = Directory.GetFiles(packageDirectory);

                if(files.Length != 0)
                foreach(var file in files)
                {
                    try
                    {
                        var fileContent = String.Empty;
                        //fileContent += "/*" + Environment.NewLine + " * File '" + file.Replace("..\\","") + "'" + Environment.NewLine + " */" + Environment.NewLine;
                        fileContent += "-- File '" + file.Replace("..\\", "") + "'" + Environment.NewLine;
                        fileContent += File.ReadAllText(file);
                        fileContent += Environment.NewLine;
                        output += fileContent;
                    }
                    catch (Exception ex) {
                        Console.WriteLine("File " + file + " not added! Exception " + ex.ToString());
                    }
                }

                if (children != null && children.Count > 0)
                    foreach (var child in children)
                        output += child.GetPackageContent(packageDirectory);
            }
            else
            {
                if (children != null && children.Count > 0)
                    foreach (var child in children)
                        output += child.GetPackageContent();
            }

            return output;
        }

        public void WritePackageContentToFile(string outputDirectory, string outputFile)
        {
            try
            {
                StreamWriter file = new StreamWriter(outputDirectory + "\\" + outputFile);
                file.WriteLine(GetPackageContent());
                file.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("WritePackageContentToFile exception: " + ex.ToString());
            }
        }
        #endregion Methods
    }
}
