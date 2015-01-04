using System;
using System.Collections.Generic;
using System.Text;
using MathWorks.MATLAB.NET.Arrays;
using MathWorks.MATLAB.NET.Utility;
using MatlabFilters;
using System.Drawing;

//change PkgName to Project Package
//change DLLCLASS to exported class in DLL
//change FunctionName to the intiating function
namespace PkgName
{
    class DLLHandler
    {
        private DLLCLASS handler1;
        public DLLHandler()
        {
            handler1 = new DLLCLASS();
        }
        public void PlaySheet(Bitmap inp)
        {
            double[][,] im = getArr(inp);
            handler1.FunctionName((MWNumericArray)im[0], size);
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
