using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace PackagingApplication
{
    /**
     * A container for scripts created from scratch based on a pattern
     */
    public class PackageContainer
    {
        #region Constructor

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

        #endregion Constructor

        #region Fields

        private string directory;
        private List<PackageContainer> children;

        #endregion Fields

        #region Methods

        public string GetPackageContent(string prefixDirectory = null)
        {
            var output = new StringBuilder();

            if (!string.IsNullOrEmpty(directory))
            {
                var packageDirectory = directory;
                if (!string.IsNullOrEmpty(prefixDirectory))
                    packageDirectory = $"{prefixDirectory}\\{packageDirectory}";
                var files = Directory.GetFiles(packageDirectory);

                if (files.Length != 0)
                    foreach (var file in files)
                    {
                        try
                        {
                            var fileContent = new StringBuilder();
                            //fileContent.Append($"/*{Environment.NewLine} * File '{file.Replace("..\\","")}'{Environment.NewLine} */{Environment.NewLine}");
                            fileContent.Append($"-- File '{file.Replace("..\\", "")}'{Environment.NewLine}");
                            fileContent.Append(File.ReadAllText(file));
                            fileContent.Append(Environment.NewLine);
                            output.Append(fileContent.ToString());
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"File {file} not added! Except    ion {ex}");
                        }
                    }

                if (children != null && children.Count > 0)
                    foreach (var child in children)
                        output.Append(child.GetPackageContent(packageDirectory));
            }
            else
            {
                if (children != null && children.Count > 0)
                    foreach (var child in children)
                        output.Append(child.GetPackageContent());
            }

            return output.ToString();
        }

        public void WritePackageContentToFile(string outputDirectory, string outputFile)
        {
            try
            {
                StreamWriter file = new StreamWriter($"{outputDirectory}\\{outputFile}");
                file.WriteLine(GetPackageContent());
                file.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"WritePackageContentToFile exception: {ex}");
            }
        }

        #endregion Methods
    }
}