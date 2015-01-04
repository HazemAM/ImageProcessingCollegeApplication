using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace OMRLink
{
    public partial class MainForm : Form
    {
        List<string> supported = new List<string> { "png", "jpg", "bmp", "tif", "tiff", "gif", "ppm" };

        public MainForm()
        {
            InitializeComponent();
        }

        private Bitmap openImage(String filePath){
            string extension = Path.GetExtension(filePath).ToLower();
            extension = extension.Substring(1, extension.Length-1);

            Bitmap bitmap = null;
            if(supported.Contains(extension))
                bitmap = new Bitmap(filePath);
            else
                MessageBox.Show("This type of files is not supported... yet.\n(Are you sure it's an image?)",
                    "Not Supported", MessageBoxButtons.OK);
            return bitmap;
        }

        private void btnRun_Click(object sender, EventArgs e)
        {
            if(pictureBox.Image != null)
            {
                DLLHandler handler = new DLLHandler();
                handler.PlaySheet(pictureBox.Image as Bitmap);
            }
        }

        private void pictureBox_DoubleClick(object sender, EventArgs e)
        {
            OpenFileDialog fileDialog = new OpenFileDialog();
            if(fileDialog.ShowDialog() == DialogResult.OK){
                Bitmap bitmap = openImage(fileDialog.FileName);
                pictureBox.Image = bitmap;
            }
        }
    }
}
