using MathWorks.MATLAB.NET.Arrays;
using OMRLibrary;
using System.Drawing;

//change PkgName to Project Package
//change DLLCLASS to exported class in DLL
//change FunctionName to the intiating function
namespace OMRLink
{
    class DLLHandler
    {
        private OMRClass OMRHandler;
        
        public DLLHandler()
        {
            OMRHandler = new OMRClass();
        }

        public void PlaySheet(Bitmap inp)
        {
            double[][,] im = getArr(inp);
            for (int j = 0; j < inp.Width; j++)
                for (int k = 0; k < inp.Height; k++)
                    im[0][j, k] = (im[0][j, k] + im[1][j, k] + im[2][j, k]) / 3.0;
            OMRHandler.OMR((MWNumericArray)im[0]);

            // Create the MATLAB instance 
            //MLApp.MLApp matlab = new MLApp.MLApp();

            // Change to the directory where the function is located 
            //matlab.Execute(@"cd D:\GitHub\ImageProcessingCollegeApplication\MATLAB files");

            // Define the output 
            //object result = null;

            // Call the MATLAB function myfunc
            //matlab.Feval("OMR", 7, out result, (MWNumericArray)im[0]);
        }
       
        private static double[][,] getArr(Bitmap inp)
        {
            double[][,] img = new double[3][,];
            img[0] = new double[inp.Width, inp.Height];
            img[1] = new double[inp.Width, inp.Height];
            img[2] = new double[inp.Width, inp.Height];
            for (int i = 0; i < inp.Width; i++)
                for (int j = 0; j < inp.Height; j++)
                {
                    Color temp = inp.GetPixel(i, j);
                    img[0][i, j] = temp.R;
                    img[1][i, j] = temp.G;
                    img[2][i, j] = temp.B;
                }
            return img;
        }
        
        private static Bitmap getImg(Bitmap inp, double[,] arr, double[,] arr1, double[,] arr2)
        {
            Bitmap img = new Bitmap(inp);
            for (int i = 0; i < inp.Width; i++)
                for (int j = 0; j < inp.Height; j++)
                {
                    img.SetPixel(i, j, Color.FromArgb((int)arr[i, j], (int)arr1[i, j], (int)arr2[i, j]));
                }
            return img;
        }
        private static Bitmap getImg(Bitmap inp, byte[,] arr, byte[,] arr1, byte[,] arr2)
        {
            Bitmap img = new Bitmap(inp);
            for (int i = 0; i < inp.Width; i++)
                for (int j = 0; j < inp.Height; j++)
                {
                    img.SetPixel(i, j, Color.FromArgb((int)arr[i, j], (int)arr1[i, j], (int)arr2[i, j]));
                }
            return img;
        }
    }
}
