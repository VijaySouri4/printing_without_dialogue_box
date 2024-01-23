from flask import Flask, request, jsonify
import os
import subprocess


# YO! start the flask server
app = Flask(__name__)


@app.route('/upload', methods=['POST'])  # upload over post
def upload_file():
    # Check if the post request has the file part
    # if 'pdf' not in request.files:
    #     return jsonify({'error': 'No file part'}), 400
    file = request.files['pdf']

    # if file.filename == '':
    #     return jsonify({'error': 'No selected file'}), 400

    if file:
        filename = 'received_file.pdf'
        filepath = os.path.join(
            '/home/vijay/projects/flutter_print/printing/printing_without_dialogue_box', filename)
        file.save(filepath)

        # Send to printer
        printer_name = 'PDF'  # This is the name of my virtual printer in CUPS
        result = subprocess.run(
            ['lp', '-d', printer_name, filepath], capture_output=True, text=True)  # CUPS command to print the given pdf file on my 'PDF' printer

        if result.returncode == 0:
            return jsonify({'message': 'Teehee yo'}), 200
        else:
            return jsonify({'error': 'No Teehee', 'details': result.stderr}), 500


if __name__ == '__main__':
    app.run(debug=True)
