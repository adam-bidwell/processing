class Branch {

  float	x1, y1, x2, y2;
  float	theta;
  float	startWidth;
  float	endWidth;
  float	totalBranchLength;
  int	branchDivisions;
  float	percentBranchless;
  float branchSizeFraction;
  float thetaGrowMax;
  float thetaSplitMax;
  float branchPercent;
  color trunkColor;  
  float length;
  float nextLength;
  float leafSize;

 
  //constructor
  Branch(
		float x,
		float y,
		float theta,
		float startWidth,
        float totalBranchLength,
		int   branchDivisions,
        float percentBranchless,
		float branchSizeFraction,
        float thetaGrowMax,
		float thetaSplitMax,
        float branchPercent,
        color trunkColor,
        float leafSize){
    this.x1 = x;
    this.y1 = y;
    this.x2 = x;
    this.y2 = y;
    this.theta = theta;
    this.endWidth = startWidth;
    this.startWidth = this.endWidth;
    this.totalBranchLength = totalBranchLength;
    this.branchDivisions = branchDivisions;
    this.percentBranchless = percentBranchless;
    this.branchSizeFraction = branchSizeFraction;
    this.thetaGrowMax = thetaGrowMax;
    this.thetaSplitMax = thetaSplitMax;
    this.branchPercent = branchPercent;
    this.trunkColor = trunkColor;
    this.leafSize = leafSize;
	this.length = 0;
  }

  void draw() {
    boolean branched = false;
    
    if (this.startWidth < 0.5)
      length = totalBranchLength;

    while (length < totalBranchLength) {
      this.endWidth = this.startWidth * (1 - length / totalBranchLength);
      if (length / totalBranchLength > percentBranchless) {
        if (random(0, 1) < branchPercent) {
          new Branch(x1, y1, theta + random(-thetaSplitMax, thetaSplitMax), this.endWidth,
                    totalBranchLength * branchSizeFraction,
					branchDivisions,
                    percentBranchless,
					branchSizeFraction,
                    thetaGrowMax,
					thetaSplitMax,
                    branchPercent,
					this.trunkColor,
					this.leafSize).draw();
          branched = true;
        }
      }
 
      nextLength = totalBranchLength / branchDivisions;
      length += nextLength;
      theta += random(-thetaGrowMax, thetaGrowMax);
      x2 = x1 + nextLength * cos(theta);
      y2 = y1 + nextLength * sin(theta);

      // draw the branch
      strokeWeight(abs(this.endWidth));
      stroke(this.trunkColor);
      line(x1, y1, x2, y2);

      x1 = x2;
      y1 = y2;
    }


    // draw a leaf on the end of the branch
    noStroke();
    color leafColor = color(0, (int) random(90, 110), 0, 220);
    fill(leafColor);
    ellipse(x2, y2, 7 * this.leafSize, 7 * this.leafSize);
    leafColor = color(0, (int) random(80, 100), 0, 220);
    fill(leafColor);
    ellipse(x2, y2, 5 * this.leafSize, 5 * this.leafSize);
  }
}

